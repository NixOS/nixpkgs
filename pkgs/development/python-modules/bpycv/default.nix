{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, fetchurl
, writeText
, blender
, minexr
, beautifulsoup4
, zcs
, requests
, opencv3
, boxx
}:

buildPythonPackage rec {
  pname = "bpycv";
  version = "0.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4N4rCVhbfJx7H7jS88QR3EcRupISIhnLuZ+cgfwIzg4=";
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
  nativeCheckInputs = [ blender ];
  checkPhase = let
    bpycv_example_data = fetchFromGitHub {
      owner = "DIYer22";
      repo = "bpycv_example_data";
      hash = "sha256-dGb6KvbXTGTu5f4AqhA+i4AwTqBoR5SdXk0vsMEcD3Q=";
      rev = "6ce0e65c107d572011394da16ffdf851e988dbb4";
    };
  in ''
    TEMPDIR=$(mktemp -d)
    pushd $TEMPDIR
      cp -r ${bpycv_example_data} example_data
      chmod +w -R example_data
      BPY_EXAMPLE_DATA=${bpycv_example_data} blender -b -P ${./bpycv-test.py}
    popd
  '';

  meta = with lib; {
    description = "Computer vision utils for Blender";
    homepage = "https://github.com/DIYer22/bpycv";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
