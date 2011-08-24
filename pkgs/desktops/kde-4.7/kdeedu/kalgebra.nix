{ kde, kdelibs, libkdeedu, readline }:
kde {
  buildInputs = [ kdelibs libkdeedu readline ];

  meta = {
    description = "2D and 3D Graph Calculator";
  };
}
