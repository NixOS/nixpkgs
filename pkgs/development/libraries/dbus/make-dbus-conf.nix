{ runCommand
, libxslt
, dbus
, findXMLCatalogs
, serviceDirectories ? []
, suidHelper ? "/var/setuid-wrappers/dbus-daemon-launch-helper"
, apparmor ? "disabled" # one of enabled, disabled, required
}:

/* DBus has two configuration parsers -- normal and "trivial", which is used
 * for suid helper. Unfortunately the latter doesn't support <include>
 * directive. That means that we can't just place our configuration to
 * *-local.conf -- it needs to be in the main configuration file.
 */
runCommand "dbus-1"
  {
    inherit serviceDirectories suidHelper apparmor;
    preferLocalBuild = true;
    allowSubstitutes = false;

    nativeBuildInputs = [
      libxslt.bin
      findXMLCatalogs
    ];

    buildInputs = [
      dbus.out
    ];
  }
  ''
    mkdir -p $out

    xsltproc --nonet \
      --stringparam serviceDirectories "$serviceDirectories" \
      --stringparam suidHelper "$suidHelper" \
      --stringparam apparmor "$apparmor" \
      ${./make-system-conf.xsl} ${dbus}/share/dbus-1/system.conf \
      > $out/system.conf
    xsltproc --nonet \
      --stringparam serviceDirectories "$serviceDirectories" \
      --stringparam apparmor "$apparmor" \
      ${./make-session-conf.xsl} ${dbus}/share/dbus-1/session.conf \
      > $out/session.conf

    # check if files are empty or only contain space characters
    grep -q '[^[:space:]]' "$out/system.conf" || (echo "\"$out/system.conf\" was generated incorrectly and is empty, try building again." && exit 1)
    grep -q '[^[:space:]]' "$out/session.conf" || (echo "\"$out/session.conf\" was generated incorrectly and is empty, try building again." && exit 1)
  ''
