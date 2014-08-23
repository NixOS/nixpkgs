{ kde, kdelibs, libkdeedu }:

kde {
  buildInputs = [ kdelibs libkdeedu ];

  meta = {
    description = "Flash Card Trainer";
  };
}
