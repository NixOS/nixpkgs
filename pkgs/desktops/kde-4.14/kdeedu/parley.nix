{ kde, kdelibs, libkdeedu, attica }:

kde {
  buildInputs = [ kdelibs libkdeedu attica ];

  meta = {
    description = "Vocabulary Trainer";
  };
}
