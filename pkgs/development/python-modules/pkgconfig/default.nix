{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pkg-config
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.5.5";
  format = "pyproject";

  inherit (pkg-config)
    setupHooks
    wrapperName
    suffixSalt
    targetPrefix
    baseBinName
    ;

  src = fetchFromGitHub {
    owner = "matze";
    repo = "pkgconfig";
    rev = "v${version}";
    sha256 = "sha256-uuLUGRNLCR3NS9g6OPCI+qG7tPWsLhI3OE5WmSI3vm8=";
  };

  patches = [ ./executable.patch ];

  postPatch = ''
    rm pkgconfig/pkgconfig.py.orig
    substituteInPlace pkgconfig/pkgconfig.py \
      --replace 'PKG_CONFIG_EXE = "pkg-config"' 'PKG_CONFIG_EXE = "${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config"'

    # those pc files are missing and pkg-config validates that they exist
    substituteInPlace data/fake-openssl.pc \
      --replace "Requires: libssl libcrypto" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedNativeBuildInputs = [ pkg-config ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkgconfig" ];

  meta = with lib; {
    description = "Interface Python with pkg-config";
    homepage = "https://github.com/matze/pkgconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
