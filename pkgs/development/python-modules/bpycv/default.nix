{
  stdenv,
  lib,
  beautifulsoup4,
  blender,
  boxx,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  minexr,
  opencv-python,
  requests,
  runCommand,
  zcs,
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
    opencv-python
    boxx
  ];

  # pythonImportsCheck = [ "bpycv" ]; # this import depends on bpy that is only available inside blender
  doCheck = false;

  passthru.tests = {
    render =
      runCommand "bpycv-render-test"
        {
          BPY_EXAMPLE_DATA = fetchFromGitHub {
            owner = "DIYer22";
            repo = "bpycv_example_data";
            hash = "sha256-dGb6KvbXTGTu5f4AqhA+i4AwTqBoR5SdXk0vsMEcD3Q=";
            rev = "6ce0e65c107d572011394da16ffdf851e988dbb4";
          };
        }
        ''
          ${blender.withPackages (ps: [ ps.bpycv ])}/bin/blender-wrapped -b -P ${./bpycv-test.py}
        '';
  };

  meta = with lib; {
    description = "Computer vision utils for Blender";
    homepage = "https://github.com/DIYer22/bpycv";
    license = licenses.mit;
    maintainers = [ maintainers.lucasew ];
    broken = stdenv.hostPlatform.isAarch64;
    inherit (blender.meta) platforms;
  };
}
