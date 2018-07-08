{ lib, python, fetchFromGitHub }:

python.pkgs.buildPythonPackage rec {
  pname = "klaus";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    sha256 = "04zjvrpx66x2c0v74nvmq8x7s7c8994cv1zwd5hfn9alq82hqcgr";
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
