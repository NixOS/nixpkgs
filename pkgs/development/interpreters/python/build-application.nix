{stdenv}:

{ package
}:

let
  # Create Python environment with our package
  env = package.python.withPackages ( ps: with ps; [ package ]);

in stdenv.mkDerivation rec {
  name = package.name;

  unpackPhase = "true";

  propagatedBuildInputs = [ env ];

  # Create symbolic links to the scripts provided our package
  # However, we link to wrapped symbolic links in our environment
  installPhase = ''
    mkdir -p "$out/bin"
    if [ -d ${package}/bin ]; then
      for prg in ${package}/bin/*; do
        if [ -f "$prg" ]; then
          echo ${env}/bin/$(basename $prg)
          ln -t $out/bin -s ${env}/bin/$(basename $prg)
        fi
      done
    fi
  '';
}


