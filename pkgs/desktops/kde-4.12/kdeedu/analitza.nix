{ kde, kdelibs, readline }:
kde {
  buildInputs = [ kdelibs readline ];

  meta = {
    description = "Library part of KAlgebra";
  };
}
