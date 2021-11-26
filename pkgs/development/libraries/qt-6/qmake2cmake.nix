/*
sample use
nixpkgs/pkgs/tools/misc/qarma-for-qt6/default.nix
*/

{ lib
, python3
, python3Packages
, git
, srcs
}:

python3Packages.buildPythonPackage rec {
  pname = "qmake2cmake";
  inherit (srcs.qtbase) src version;
  sourceRoot = "qtbase-everywhere-src-${version}/util/cmake";

  propagatedBuildInputs =
    (with python3Packages; [ pyparsing portalocker sympy ])
    ++ [ git ];

  checkInputs = with python3Packages; [ pytest ];

  patchPhase = ''
    mv pro2cmake.py ${pname} # rename
    ln -s ${pname} pro2cmake.py # alias

    cat >setup.py <<'EOF'
    #! ${python3.interpreter}
    from distutils.core import setup
    setup(
      name='${pname}',
      version='${version}',
      scripts=['${pname}'],
    )
    EOF

    # fix: read-only filesystem
    sed -i 's|cache_path = get_cache_location()|cache_path = "/tmp/${pname}-cache.json"|' condition_simplifier_cache.py
  '';

  # copy dependencies
  postInstall = ''
    chmod -x *.py
    cp -a *.py $out/bin/
    rm $out/bin/setup.py
  '';

  meta = with lib; {
    description = "Convert simple QMake projects to CMake";
    longDescription = ''
      This tool can only convert *simple* qmake projects.
      More complex qmake projects must be converted by hand
    '';
    homepage = "https://www.qt.io/";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ milahu ];
  };
}
