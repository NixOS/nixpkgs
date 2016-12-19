{ fetchurl, kde, kdelibs, nepomuk_core }:

kde {

  src = fetchurl {
    url = "mirror://kde/stable/4.13.3/src/kactivities-4.13.3.tar.xz";
    sha256 = "12l9brpq8mr9hqqmnlz9xfsfr8ry6283b32nfqfx0p3f7w19vjy7";
  };

  outputs = [ "out" "dev" ];

  outputInclude = "out";

  setOutputFlags = false;

  propagatedBuildInputs = [ kdelibs nepomuk_core ];

  meta = {
    description = "KDE activities library and daemon";
  };
}
