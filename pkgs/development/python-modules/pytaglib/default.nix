{ lib
, buildPythonPackage
, fetchFromGitHub
, taglib
, cython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytaglib";
  version = "1.5.0-1";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nssiqzlzvzdd3pc5xd1qwgwgkyazynmq8qiljz0dhy0c8j6mkfp";
  };

  buildInputs = [
    cython
    taglib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "taglib" ];

  meta = with lib; {
    description = "Python bindings for the Taglib audio metadata library";
    homepage = "https://github.com/supermihi/pytaglib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mrkkrp ];
  };
}
