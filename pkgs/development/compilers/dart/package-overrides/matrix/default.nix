{ openssl
}:

{ ... }:

{ runtimeDependencies ? [ ]
, ...
}:

{
  runtimeDependencies = runtimeDependencies ++ [ openssl ];
}
