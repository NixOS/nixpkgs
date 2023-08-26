{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, setuptools
, wheel
, bitlist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gYVguXMVrXxra/xy+R4RXVk9yDGKiKE8u3qWUk8sjt4=";
  };

  patches = [
    # https://github.com/reity/fountains/pull/1
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/reity/fountains/commit/50a6c0e5e0484ba1724320bf82facb29d2c7166e.patch";
      hash = "sha256-TVWj1tRE+IJ/ukGf3PSdEhHR/oLjKbT9ExqM4iczu1Q=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bitlist
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "fountains"
  ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
