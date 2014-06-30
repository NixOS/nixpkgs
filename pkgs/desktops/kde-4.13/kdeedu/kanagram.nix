{ kde, kdelibs, libkdeedu }:
kde {
  buildInputs = [ kdelibs libkdeedu ];

  meta = {
    description = "Letter Order Game";
  };
}
