{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  xterm,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "tagtime";
  version = "2018-09-02";

  src = fetchFromGitHub {
    owner = "tagtime";
    repo = "TagTime";
    rev = "59343e2cbe451eb16109e782c194ccbd0ee4196d";
    sha256 = "1xpmra3f9618b0gajfxqh061r4phkiklvcgpglsyx82bhmgf9n1f";
  };

  buildInputs = [
    perl
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{libexec,bin}

    # We don’t support a config file for now,
    # since it’s not entirely clear how to split nix-set paths
    # from the actual config options.
    for pl in *.pl; do
      substituteInPlace "$pl" \
        --replace 'require "$ENV{HOME}/.tagtimerc";' \
                  'require "${placeholder "out"}/libexec/settings.pl";'
    done;

    install tagtimed.pl $out/bin/tagtimed

    substituteInPlace util.pl \
      --replace '/usr/bin/touch' \
                '${coreutils}/bin/touch' \
      --replace '/bin/rm -f $lockf' \
                '${coreutils}/bin/rm -f $lockf' \
      --replace '$lockf = "''${path}tagtime.lock";' \
                'mkdir "$ENV{HOME}/.cache/tagtime";
    $lockf = "$ENV{HOME}/.cache/tagtime/tagtime.lock";'

    mv *.pl $out/libexec/
    mv template.tsk $out/libexec/


    # set the default template arguments to sane defaults.
    substitute settings.pl.template $out/libexec/settings.pl \
      --replace '"__USER__"' \
                'getlogin()' \
      --replace '"__PATH__"' \
                '"${placeholder "out"}/libexec/"' \
      --replace '$logf = "$path$usr.log";' \
                'mkdir "$ENV{HOME}/.local/share/tagtime";
    $logf = "$ENV{HOME}/.local/share/tagtime/pings.log";' \
      --replace '"__ED__ +"' \
                '$ENV{"EDITOR"}' \
      --replace '"__XT__"' \
                '"${xterm}/bin/xterm"'

    runHook postInstall
  '';

  meta = {
    description = "Stochastic Time Tracking for Space Cadets";
    longDescription = ''
      To determine how you spend your time, TagTime literally randomly samples
      you. At random times it pops up and asks what you're doing right at that
      moment. You answer with tags.

      See https://messymatters.com/tagtime for the whole story.

      [maintainer’s note]: This is the original perl script implementation.
    '';
    homepage = "http://messymatters.com/tagtime/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.Profpatsch ];
    mainProgram = "tagtimed";
  };
}
