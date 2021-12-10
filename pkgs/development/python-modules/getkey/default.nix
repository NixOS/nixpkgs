{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, flake8
}:

buildPythonPackage rec {
  pname = "getkey";
  version = "0.6.5";

  src = fetchFromGitHub {
     owner = "kcsaff";
     repo = "getkey";
     rev = "v0.6.5";
     sha256 = "0bj1yzq28z8k5ghbpdpsr1vzkqxwi5fq4r074k5gb8pf92cdqm2v";
  };

  # disable coverage, because we don't care and python-coveralls is not in nixpkgs
  postPatch = ''
    sed -e '/python-coveralls/d' -e '/pytest-cov/d' -i setup.py
    rm setup.cfg
  '';

  checkInputs = [
    flake8
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Read single characters and key-strokes";
    homepage = "https://github.com/kcsaff/getkey";
    license = licenses.mit;
    maintainers = [ maintainers.symphorien ];
  };
}
