{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, hopcroftkarp
, multiset
, pytest
, pytestrunner
, hypothesis
, setuptools_scm
, isPy27
}:

buildPythonPackage rec {
  pname = "matchpy";
  version = "0.5.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vvf1cd9kw5z1mzvypc9f030nd18lgvvjc8j56b1s9b7dyslli2r";
  };

  patches = [
    # Fix tests for pytest 4. Remove with the next release
    (fetchpatch {
      url = "https://github.com/HPAC/matchpy/commit/b405a2717a7793d58c47b2e2197d9d00c06fb13c.patch";
      includes = [ "tests/conftest.py" ];
      sha256 = "1b6gqf2vy9qxg384nqr9k8il335afhbdmlyx4vhd8r8rqpv7gax9";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
       --replace "hypothesis>=3.6,<4.0" "hypothesis" \
       --replace "pytest>=3.0,<4.0" "pytest"
  '';

  buildInputs = [ setuptools_scm pytestrunner ];
  checkInputs = [ pytest hypothesis ];
  propagatedBuildInputs = [ hopcroftkarp multiset ];

  meta = with lib; {
    description = "A library for pattern matching on symbolic expressions";
    homepage = "https://github.com/HPAC/matchpy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
