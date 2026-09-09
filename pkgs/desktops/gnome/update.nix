{
  stdenv,
  pkgs,
  lib,
  writeScript,
  python3,
  common-updater-scripts,
}:
{
  packageName,
  attrPath ? packageName,
  versionPolicy ? "tagged",
  freeze ? false,
}:

let
  python = python3.withPackages (p: [
    p.requests
    p.libversion
  ]);
  package =
    lib.attrByPath (lib.splitString "." attrPath) (throw "Cannot find attribute ‘${attrPath}’.")
      pkgs;
  packageVersion = lib.getVersion package;
  upperBound =
    let
      versionComponents = lib.versions.splitVersion packageVersion;
      minorVersion = lib.versions.minor packageVersion;
      minorAvailable =
        builtins.length versionComponents > 1 && builtins.match "[0-9]+" minorVersion != null;
      nextMinor = builtins.fromJSON minorVersion + 1;
      upperBound = "${lib.versions.major packageVersion}.${toString nextMinor}";
    in
    if builtins.isBool freeze then
      lib.optionals (freeze && minorAvailable) [ upperBound ]
    else if builtins.isString freeze then
      [ freeze ]
    else
      throw "“freeze” argument needs to be either a boolean, or a version string.";
  updateScript = writeScript "gnome-update-script" ''
    #!${python}/bin/python
    import json
    import os
    import subprocess
    import sys
    from libversion import Version

    _, attr_path, package_name, package_version, version_policy, *remaining_args = sys.argv

    flv_args = [
        package_name,
        version_policy,
        os.environ.get("GNOME_UPDATE_STABILITY", "stable"),
    ]

    match remaining_args:
        case []:
            pass
        case [upper_bound]:
            flv_args.append(f"--upper-bound={upper_bound}")
        case other:
            print("gnome-update-script: Received too many arguments.", file=sys.stderr)
            sys.exit(1)

    latest_tag = subprocess.check_output(
        [
            "${python}/bin/python",
            "${./find-latest-version.py}",
            *flv_args,
        ],
        encoding="utf-8",
    )

    if Version(latest_tag) <= Version(package_version):
        # No newer updates found.
        print(json.dumps([]))
        sys.exit(0)

    latest_tag = latest_tag.strip()
    subprocess.run(
        [
            "${common-updater-scripts}/bin/update-source-version",
            attr_path,
            latest_tag,
        ],
        check=True,
    )

    report = [
        {
            "attrPath": attr_path,
            "commitBody": f"https://gitlab.gnome.org/GNOME/{package_name}/-/compare/{package_version}...{latest_tag}",
        },
    ]

    print(json.dumps(report))
  '';
in
{
  name = "gnome-update-script";
  command = [
    updateScript
    attrPath
    packageName
    packageVersion
    versionPolicy
  ]
  ++ upperBound;
  supportedFeatures = [
    "commit"
  ];
  inherit attrPath;
}
