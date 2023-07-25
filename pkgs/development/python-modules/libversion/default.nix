{ lib
, buildPythonPackage
, fetchFromGitHub
, libversion
, pkg-config
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "py-libversion";
    rev = version;
    hash = "sha256-p0wtSB+QXAERf+57MMb8cqWoy1bG3XaCpR9GPwYYvJM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pkg-config'" "'$(command -v $PKG_CONFIG)'"
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libversion
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm -r libversion
  '';

  pythonImportsCheck = [
    "libversion"
  ];

  meta = with lib; {
    description = "Python bindings for libversion, which provides fast, powerful and correct generic version string comparison algorithm";
    homepage = "https://github.com/repology/py-libversion";
    license = licenses.mit;
    maintainers = with maintainers; [ ryantm ];
  };
}
