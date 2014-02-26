{ kde, kdelibs, libkdeedu, analitza }:
kde {
  buildInputs = [ kdelibs libkdeedu analitza ];

  meta = {
    description = "2D and 3D Graph Calculator";
  };
}
