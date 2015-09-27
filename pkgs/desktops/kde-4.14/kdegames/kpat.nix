{ kde, kdelibs, libkdegames, shared_mime_info }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  nativeBuildInputs = [ shared_mime_info ];
  meta = {
    description = "a relaxing card sorting game";
  };
}
