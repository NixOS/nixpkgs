{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pytestCheckHook, pytest-mock, poetry-core
, requests, python-dateutil, jsonschema, deprecated
}:

let version = "2.4.174"; in

buildPythonPackage {
  pname = "pymisp";
  inherit version;
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "MISP";
    repo = "PyMISP";
    rev = "v${version}";
    hash = "sha256-OBchUEz+ZK6XNbnFFL6nsCuXniZ0vAfdJLj6LaFC2i0=";
  };

  patches = [ ./pymisp-remove-poetry-group.patch ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'jsonschema = "^4.18.4"' 'jsonschema = "*"' \
      --replace 'requests = "^2.31.0"' 'requests = "*"' \
      --replace 'deprecated = "^1.2.14"' 'deprecated = "*"' \
      --replace 'publicsuffixlist = {version = "^0.10.0.20230730", optional = true}' ""
  '';

  nativeBuildInputs = [ poetry-core ];

  checkInputs = [ pytestCheckHook pytest-mock ];

  propagatedBuildInputs = [
    requests python-dateutil jsonschema deprecated
  ];

  # testing optional email feature
  pytestFlagsArray = [ "--ignore tests/test_emailobject.py" ];

  disabledTests = [
    "test_mime"
    "test_default_attributes"
    "test_feed"
    "test_git_vuln_finder"
    "test_obj_default_values"
    "test_object_galaxy"
    "test_object_tag"
    "test_to_dict_json_format"
  ];

  meta = with lib; {
    description = "Python API for MISP";
    homepage =  "https://github.com/MISP/PyMISP";
    maintainers = [ maintainers.jsoo1 ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
