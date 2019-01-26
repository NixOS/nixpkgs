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
  version = "0.163.0-40-gb4b1ec7";
  disabled = isPy3k;    # urlgrabber doesn't support python-3.x

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = "b4b1ec7b64d4f9bb42f140754519221b810e232c";
    sha256 = "01z1b15x9vzhd7j94f6n3g50h5br7lwz86akgic0wpp41zv37jad";
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
