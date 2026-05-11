{
  build-idris-package,
  fetchFromGitLab,
  lightyear,
  lib,
}:
build-idris-package {
  pname = "graphviz";
  version = "2017-01-16";

  idrisDeps = [ lightyear ];

  src = fetchFromGitLab {
    owner = "mgttlinger";
    repo = "idris-graphviz";
    rev = "805da92ac888530134c3b4090fae0d025d86bb05";
    sha256 = "12kzgjlwq6adflfc5zxpgjnaiszhiab6dcp878ysbz3zr2sihljx";
  };

  postUnpack = ''
    sed -i "/^author /cauthor = Merlin Goettlinger" source/graphviz.ipkg
  '';

  meta = {
    description = "Parser and library for graphviz dot files";
    homepage = "https://gitlab.com/mgttlinger/idris-graphviz";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
