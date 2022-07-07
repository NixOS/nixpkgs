{ lib, buildPythonPackage, fetchPypi
, fetchpatch
, packaging
, python
, pythonAtLeast
, pythonOlder
, unittest2
}:

buildPythonPackage rec {
  pname = "deprecation";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zqqjlgmhgkpzg9ss5ki8wamxl83xn51fs6gn2a8cxsx9vkbvcvj";
  };

  patches = lib.optionals (pythonAtLeast "3.10") [
    # fixes for python 3.10 test suite
    (fetchpatch {
      url = "https://github.com/briancurtin/deprecation/pull/57/commits/e13e23068cb8d653a02a434a159e8b0b7226ffd6.patch";
      sha256 = "sha256-/5zr2V1s5ULUZnbLXsgyHxZH4m7/a27QYuqQt2Savc8=";
      includes = [ "tests/test_deprecation.py" ];
    })
  ];

  propagatedBuildInputs = [ packaging ];

  # avoiding mass rebuilds for python3.9, but no longer
  # needed with patch
  checkInputs = lib.optional (pythonOlder "3.10") [
    unittest2
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "A library to handle automated deprecations";
    homepage = "https://deprecation.readthedocs.io/";
    license = licenses.asl20;
  };
}
