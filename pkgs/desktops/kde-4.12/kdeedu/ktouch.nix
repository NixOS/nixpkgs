{ kde, kdelibs, libxkbfile }:

kde {
  buildInputs = [ kdelibs libxkbfile ];

  meta = {
    description = "Touch Typing Tutor";
  };
}
