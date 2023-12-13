{ olm
}:

{ ... }:

{ runtimeDependencies ? [ ]
, ...
}:

{
  runtimeDependencies = runtimeDependencies ++ [ olm ];
}
