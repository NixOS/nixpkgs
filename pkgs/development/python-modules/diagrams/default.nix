{ lib
, fetchFromGitHub
, buildPythonPackage
, fetchPypi
, isPy3k
, graphviz
}:

buildPythonPackage rec {
  pname = "diagrams";
  version = "0.17.0";
  disabled = ! isPy3k;

  # TODO consider packaging from Github: https://github.com/mingrammer/diagrams
  # note: outscale package is broken, __init__.py is missing
  src = fetchPypi {
    inherit pname version;
    sha256 = "17v5nzswva74bawxrvkza8a5d9aqyhb2gkncp3fqv6rszmk62hw6";
  };

  patches = [
    ./diags_fix_aliases.patch
  ];

  # This script is patching setup.py from the pypi tarball, to retain
  # the png images which this library uses to generate diagrams.
  postPatch = ''
    # fix resource lookup path
    sed -i \
    -e "/basedir = Path(os.path.abspath(os.path.dirname(__file__)))/d" \
    -e "s|join(basedir.parent|join('$out'|" \
    diagrams/__init__.py

    # for setup.py: get all directories which contain any '.png' files
    png_dirs=$(find resources -type f -name "*.png" -printf '%h\n' | sort -u)
    dirs=($png_dirs)

    # rewrite 'setup(...)' to add data_files
    spacedSetup=$(echo -e "setup(\n    **setup_kwargs,")

    substituteInPlace setup.py \
      --replace 'setup(**setup_kwargs)' "''${spacedSetup}" \
      --replace 'graphviz>=0.13.2,<0.14.0' 'graphviz>=0.14.0,<0.15.0' \
      --replace ", 'jinja2>=2.10,<3.0'" ""  # not used when building from the source tarball

    # scan dirs for pngs, building up the (directory, files) structure for data_files
    {
      echo "    data_files=["
      for d in ''${dirs[*]}
      do
        echo "        (''\'''${d}''\', ["
        printf "            "
        find "''${d}" -type f -name "*.png" -printf "'%p', " | sed 's/, $//'
        echo "]),"
      done
      echo "    ],)"
    } >> setup.py
  '';

  buildInputs = [ graphviz ];

  meta = with lib; {
    description = "Generate infrastructure images from code";
    homepage    = "https://diagrams.mingrammer.com/";
    license     = licenses.mit;
    maintainers =  with maintainers; [ addict3d ];
  };
}
