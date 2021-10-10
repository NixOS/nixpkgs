{ pytest
, cffi
, wayland
, pkg-config
, buildPythonApplication
, fetchFromGitHub
, setuptools
}:
buildPythonApplication rec {
  name = "pywayland-${version}";
  version = "0.4.7";
  src = fetchFromGitHub {
    owner = "flacjacket";
    repo = "pywayland";
    rev = "v${version}";
    sha256 = "bFjw8sjB+Zo4F5i2Jo7srMa8po+URcLVvu1QoU9scvM=";
  };
  nativeBuildInputs = [
    setuptools
    cffi
    wayland
  ];
  propagatedBuildInputs = nativeBuildInputs;
  preBuild = ''
        python ./pywayland/ffi_build.py
        python -m pywayland.scanner
  '';
  checkInputs = [
    pytest
    pkg-config
  ];
  checkPhase = ''
    export XDG_RUNTIME_DIR=/tmp
    pytest
  '';
  doCheck = true;
}
