{ lib
, buildPythonPackage
, fetchFromGitHub
, ipython
, isPyPy
, mock
, toml
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.9";
  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchFromGitHub {
     owner = "gotcha";
     repo = "ipdb";
     rev = "0.13.9";
     sha256 = "1nhjk53xn3bmf338xazq8znqifa8zm2swl3cvy3jwydfhcs7fzf2";
  };

  propagatedBuildInputs = [ ipython toml ];
  checkInputs = [ mock ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/gotcha/ipdb";
    description = "IPython-enabled pdb";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };

}
