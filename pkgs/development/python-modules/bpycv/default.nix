{ stdenv
, lib
, beautifulsoup4
, blender
, blender-with-packages
, boxx
, bpycv
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, fetchurl
, minexr
, opencv3
, python3Packages
, requests
, runCommand
, writeText
, zcs
}:

buildPythonPackage rec {
  pname = "bpycv";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qqNGemDB0aagCXjrECuh6kLksf+KujPejpnXVqFG8GY=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    minexr
    zcs
    requests
    opencv3
    boxx
  ];

  postPatch = ''
    sed -i 's/opencv-python//g' requirements.txt
  '';

  # pythonImportsCheck = [ "bpycv" ]; # this import depends on bpy that is only available inside blender
  doCheck = false;

  passthru.tests = {
    render = runCommand "bpycv-render-test" {
      BPY_EXAMPLE_DATA = fetchFromGitHub {
        owner = "DIYer22";
        repo = "bpycv_example_data";
        hash = "sha256-dGb6KvbXTGTu5f4AqhA+i4AwTqBoR5SdXk0vsMEcD3Q=";
        rev = "6ce0e65c107d572011394da16ffdf851e988dbb4";
      };
      nativeBuildInputs = [
        ((blender-with-packages.override {inherit blender python3Packages;}) {
          packages = [ bpycv ];
        })
      ];
    } ''
      blender-wrapped -b -P ${./bpycv-test.py}
    '';
  };

  meta = with lib; {
    description = "Computer vision utils for Blender";
    homepage = "https://github.com/DIYer22/bpycv";
    license = licenses.mit;
    maintainers = [ maintainers.lucasew ];
    broken = stdenv.isAarch64;
    inherit (blender.meta) platforms;
  };
}
