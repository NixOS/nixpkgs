{ libayatana-appindicator-gtk3
, libayatana-appindicator
, libayatana-indicator
, libayatana-indicator-gtk3
}:

{ ... }:

{ runtimeDependencies ? [ ]
, buildInputs ? [ ]
, ...
}:

{
  buildInputs = buildInputs ++ [
    libayatana-indicator
    libayatana-indicator-gtk3
    libayatana-appindicator
    libayatana-appindicator-gtk3
    libayatana-appindicator.dev
    libayatana-appindicator-gtk3.dev
  ];
  runtimeDependencies = runtimeDependencies ++ [
    libayatana-indicator
    libayatana-indicator-gtk3
    libayatana-appindicator
    libayatana-appindicator-gtk3
  ];
}
