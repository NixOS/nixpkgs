{ kde, kdelibs, libkdeedu, libxml2, attica }:

kde {
  buildInputs = [ kdelibs libkdeedu libxml2 attica ];

  meta = {
    description = "Vocabulary Trainer";
  };
}
