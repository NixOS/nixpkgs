{ lib
, buildPythonPackage
, fetchFromGitHub
, taglib
, cython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytaglib";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UAWXR1MCxEB48n7oQE+L545F+emlU3HErzLX6YTRteg=";
  };

  buildInputs = [
    cython
    taglib
  ];

  checkInputs = [
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
