{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f8kFJyzvpPNkwaNCnLvpwPmLeTmI77W/kKrIDwjbCbE=";
  };

  patches = [
    (fetchpatch2 {
      name = "parameterized-docstring-3.13-compat.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-python/parameterized/files/parameterized-0.9.0-py313-test.patch?id=dec60bb6900d6ebdaaa6aa1dcb845b30b739f9b5";
      hash = "sha256-tWcN0eRC0oRHrOaa/cctXLhi1WapDKvxO36e6gU6UIk=";
    })
  ];

  postPatch = ''
    # broken with pytest 7 and python 3.12
    # https://github.com/wolever/parameterized/issues/167
    # https://github.com/wolever/parameterized/pull/162
    substituteInPlace parameterized/test.py \
      --replace 'assert_equal(missing, [])' "" \
      --replace "assertRaisesRegexp" "assertRaisesRegex"
  '';

  nativeBuildInputs = [ setuptools ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "parameterized/test.py" ];

  pythonImportsCheck = [ "parameterized" ];

  meta = with lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = "https://github.com/wolever/parameterized";
    changelog = "https://github.com/wolever/parameterized/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
