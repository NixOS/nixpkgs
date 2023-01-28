{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "cdent";
    repo = "paste";
    rev = version;
    sha256 = "sha256-yaOxbfQ8rdViepxhdF0UzlelC/ozdsP1lOdU5w4OPEQ=";
  };

  postPatch = ''
    patchShebangs tests/cgiapp_data/
  '';

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # broken test
    "test_file_cache"
    # requires network connection
    "test_proxy_to_website"
  ];

  pythonNamespaces = [ "paste" ];

  meta = with lib; {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = "http://pythonpaste.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
