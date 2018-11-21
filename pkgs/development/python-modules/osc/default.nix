{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pkgs
, urlgrabber
, m2crypto
, pyyaml
, lxml
}:

buildPythonPackage {
  pname = "osc";
  version = "0.162.0-55-gb730f88";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = "b730f880cfe85a8547f569355a21706f27ebfa78";
    sha256 = "0hh9j5zd2kc0804d2jmf1q3w5xm9l9s69hhgysbncrv5fw0414lh";
  };

  buildInputs = [ pkgs.bashInteractive ]; # needed for bash-completion helper
  propagatedBuildInputs = [ urlgrabber m2crypto pyyaml lxml ];

  postInstall = ''
    ln -s $out/bin/osc-wrapper.py $out/bin/osc
    install -D -m444 osc.fish $out/etc/fish/completions/osc.fish
    install -D -m555 dist/osc.complete $out/share/bash-completion/helpers/osc-helper
    mkdir -p $out/share/bash-completion/completions
    cat >>$out/share/bash-completion/completions/osc <<EOF
    test -z "\$BASH_VERSION" && return
    complete -o default _nullcommand >/dev/null 2>&1 || return
    complete -r _nullcommand >/dev/null 2>&1         || return
    complete -o default -C $out/share/bash-completion/helpers/osc-helper osc
    EOF
  '';

  meta = with stdenv.lib; {
    description = "opensuse-commander with svn like handling";
    maintainers = [ maintainers.peti ];
    license = licenses.gpl2;
  };

}
