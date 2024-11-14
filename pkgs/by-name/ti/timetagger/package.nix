{ python3

, addr ? "127.0.0.1"
, port ? 8082
}:

#
# Timetagger itself is a library that a user must write a "run.py" script for
# We provide a basic "run.py" script with this package, which simply starts
# timetagger.
#

python3.pkgs.buildPythonApplication {
  inherit (python3.pkgs.timetagger) pname version src meta;

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    timetagger
  ];

  format = "custom";
  installPhase = ''
    mkdir -p $out/bin
    echo "#!${python3.interpreter}" >> $out/bin/timetagger
    cat timetagger/__main__.py >> $out/bin/timetagger
    chmod +x $out/bin/timetagger
    wrapProgram $out/bin/timetagger \
      --set TIMETAGGER_BIND "${addr}:${toString port}"
  '';
}

