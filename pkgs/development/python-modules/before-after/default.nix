{ buildPythonPackage, fetchPypi, fetchpatch, pytestCheckHook, lib }:

buildPythonPackage rec {
  pname = "before-after";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "before_after";
    inherit version;
    hash = "sha256-x9T5uLi7UgldoUxLnFnqaz9bnqn9zop7/HLsrg9aP4U=";
  };

  patches = [
    # drop 'mock' dependency for python >=3.3
    (fetchpatch {
      url = "https://github.com/c-oreills/before_after/commit/cf3925148782c8c290692883d1215ae4d2c35c3c.diff";
      hash = "sha256-FYCpLxcOLolNPiKzHlgrArCK/QKCwzag+G74wGhK4dc=";
    })
    (fetchpatch {
      url = "https://github.com/c-oreills/before_after/commit/11c0ecc7e8a2f90a762831e216c1bc40abfda43a.diff";
      hash = "sha256-8YJumF/U8H+hc7rLZLy3UhXHdYJmcuN+O8kMx8yqMJ0=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "before_after" ];

  meta = with lib; {
    description = "sugar over the Mock library to help test race conditions";
    homepage = "https://github.com/c-oreills/before_after";
    maintainers = with maintainers; [ yuka ];
    license = licenses.gpl2Only;
  };
}
