{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "more-properties";
  version = "1.1.1";

  # upstream requires >= 3.6 but only 3.7 includes dataclasses
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "madman-bob";
    repo = "python-more-properties";
    rev = version;
    hash = "sha256-dKG97rw5IG19m7u3ZDBM2yGScL5cFaKBvGZxPVJaUTE=";
  };

  postPatch = ''
    mv pypi_upload/setup.py .
    substituteInPlace setup.py \
      --replace "project_root = Path(__file__).parents[1]" "project_root = Path(__file__).parents[0]"

    # dataclasses is included in Python 3.7
    substituteInPlace requirements.txt \
      --replace dataclasses ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "more_properties" ];

  meta = {
    description = "A collection of property variants";
    homepage = "https://github.com/madman-bob/python-more-properties";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
