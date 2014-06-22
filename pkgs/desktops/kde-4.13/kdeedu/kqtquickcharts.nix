{ kde, kdelibs, libkdeedu }:
kde {
  buildInputs = [ kdelibs libkdeedu ];

  meta = {
    description = "KDE Qt Quick Charts";
  };
}
