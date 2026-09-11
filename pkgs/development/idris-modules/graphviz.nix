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
    hash = "sha256-XVIYtch//KU9OuiyZpaK8OuorHy3/8IcdU0ZzKl8f4o=";
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
