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
    mv pro2cmake.py ${pname}
    ln -s ${pname} pro2cmake.py # for tests

    cat >setup.py <<'EOF'
    #! ${python3.interpreter}
    from distutils.core import setup
    setup(
      name='${pname}',
      version='${version}',
      #packages=['distutils', 'distutils.command'],
      scripts=['${pname}'],
    )
    EOF

    # fix: read-only filesystem
    sed -i 's|cache_path = get_cache_location()|cache_path = "/tmp/${pname}-cache.json"|' condition_simplifier_cache.py

    # copy dependencies
    mkdir -p $out/bin
    for f in *.py
    do
      cp $f $out/bin/
    done
    chmod -x $out/bin/*.py

    # fix tests
    export HOME=/tmp
  '';

  # use original name as alias
  postInstall = ''
    rm $out/bin/pro2cmake.py
    ln -s ${pname} $out/bin/pro2cmake.py
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
