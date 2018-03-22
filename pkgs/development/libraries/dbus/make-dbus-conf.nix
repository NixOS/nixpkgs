{ runCommand, writeText, libxslt, dbus
, serviceDirectories ? []
, suidHelper ? "/var/setuid-wrappers/dbus-daemon-launch-helper"
}:

/* DBus has two configuration parsers -- normal and "trivial", which is used
 * for suid helper. Unfortunately the latter doesn't support <include>
 * directive. That means that we can't just place our configuration to
 * *-local.conf -- it needs to be in the main configuration file.
 */
runCommand "dbus-1"
  {
    inherit serviceDirectories suidHelper;
    preferLocalBuild = true;
    XML_CATALOG_FILES = writeText "dbus-catalog.xml" ''
      <?xml version="1.0"?>
      <!DOCTYPE catalog PUBLIC
        "-//OASIS//DTD Entity Resolution XML Catalog V1.0//EN"
        "http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd">

      <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
        <rewriteSystem
          systemIdStartString="http://www.freedesktop.org/standards/dbus/1.0/"
          rewritePrefix="file://${dbus}/share/xml/dbus/"/>
      </catalog>
    '';
    nativeBuildInputs = [ libxslt.bin ];
  }
  ''
    mkdir -p $out

    xsltproc --nonet \
      --stringparam serviceDirectories "$serviceDirectories" \
      --stringparam suidHelper "$suidHelper" \
      ${./make-system-conf.xsl} ${dbus}/share/dbus-1/system.conf \
      > $out/system.conf
    xsltproc --nonet \
      --stringparam serviceDirectories "$serviceDirectories" \
      ${./make-session-conf.xsl} ${dbus}/share/dbus-1/session.conf \
      > $out/session.conf
  ''
