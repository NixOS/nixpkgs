{ kde, kdelibs }:

kde rec {
  name = "kde-sounds";

  buildInputs = [ kdelibs ];

  meta = {
    description = "New login/logout sounds";
  };
}
