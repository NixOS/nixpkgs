{ runCommand, libxslt, dbus, serviceDirectories ? [], suidHelper ? "/var/setuid-wrappers/dbus-daemon-launch-helper" }:

/* DBus has two configuration parsers -- normal and "trivial", which is used
 * for suid helper. Unfortunately the latter doesn't support <include>
 * directive. That means that we can't just place our configuration to
 * *-local.conf -- it needs to be in the main configuration file.
 */
runCommand "dbus-1"
  {
    buildInputs = [ libxslt ];
    inherit serviceDirectories suidHelper;
  }
  ''
    mkdir -p $out

    xsltproc \
      --stringparam serviceDirectories "$serviceDirectories" \
      --stringparam suidHelper "$suidHelper" \
      --path ${dbus.doc}/share/xml/dbus \
      ${./make-system-conf.xsl} ${dbus}/share/dbus-1/system.conf \
      > $out/system.conf
    xsltproc \
      --stringparam serviceDirectories "$serviceDirectories" \
      --path ${dbus.doc}/share/xml/dbus \
      ${./make-session-conf.xsl} ${dbus}/share/dbus-1/session.conf \
      > $out/session.conf
  ''
