{ lib, python, fetchFromGitHub }:

python.pkgs.buildPythonPackage rec {
  pname = "klaus";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    sha256 = "041l5dpymi9h0yyr55r6m0skp0m2ags3miay0s1bgfcp469k0l20";
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
