{ lib, fetchFromGitHub, buildPythonPackage, python, flake8, six,
  fetchurl }:

buildPythonPackage rec {
  pname = "flake8-future-import";
  name = "${pname}-${version}";
  version = "0.4.3";
  # PyPI tarball doesn't include the test suite
  src = fetchFromGitHub {
    owner = "xZise";
    repo = "flake8-future-import";
    rev = version;
    sha256 = "0622bdcfa588m7g8igag6hf4rhjdwh74yfnrjwlxw4vlqhg344k4";
  };

  patches = [
    # Tests in 0.4.3 are broken. We can remove this patch after
    # the next release.
    (fetchurl {
      url = "https://github.com/xZise/flake8-future-import/commit/b4f5a06b22c574fb5270574d1420715667768d5c.patch";
      sha256 = "06n9ggz9p9kiwjb3vmaj44pm5vi4nhgzjfn7i730m85xn67xzmyn";
    })
  ];


  propagatedBuildInputs = [ flake8 six ];
  meta = {
    homepage = https://github.com/xZise/flake8-future-import;
    description = "A flake8 extension to check for the imported __future__ modules to make it easier to have a consistent code base";
    license = lib.licenses.mit;
  };
}
