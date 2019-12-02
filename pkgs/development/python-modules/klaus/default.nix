{ lib, python, fetchFromGitHub }:

python.pkgs.buildPythonPackage rec {
  pname = "klaus";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    sha256 = "0pagyqfcj47ghd9m7b32hvi17hbl19f0wallkz6ncvmvvy919lfz";
  };

  prePatch = ''
    substituteInPlace runtests.sh \
      --replace "mkdir -p \$builddir" "mkdir -p \$builddir && pwd"
  '';

  propagatedBuildInputs = with python.pkgs; [
    six flask pygments dulwich httpauth humanize
  ];

  checkInputs = with python.pkgs; [
    pytest requests python-ctags3
  ] ++ lib.optional (!isPy3k) mock;

  checkPhase = ''
    ./runtests.sh
  '';

  # Needs to set up some git repos
  doCheck = false;

  meta = with lib; {
    description = "The first Git web viewer that Just Works";
    homepage    = https://github.com/jonashaag/klaus;
    license     = licenses.isc;
    maintainers = with maintainers; [ pSub ];
  };
}
