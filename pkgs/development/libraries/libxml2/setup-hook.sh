addXMLCatalogs () {
    for kind in dtd xsl; do
        if test -d $1/xml/$kind; then
            for i in $(find $1/xml/$kind -name catalog.xml); do
                export XML_CATALOG_FILES="$XML_CATALOG_FILES $i"
            done
        fi
    done
}

if test -z "$libxmlHookDone"; then
    libxmlHookDone=1

    # Set http_proxy and ftp_proxy to a invalid host to prevent
    # xmllint and xsltproc from trying to download DTDs from the
    # network even when --nonet is not given.  That would be impure.
    # (Note that .invalid is a reserved domain guaranteed not to
    # work.)
    export http_proxy=http://nodtd.invalid/
    export ftp_proxy=http://nodtd.invalid/

    # Set up XML_CATALOG_FILES.  An empty initial value prevents
    # xmllint and xsltproc from looking in /etc/xml/catalog.
    export XML_CATALOG_FILES
    if test -z "$XML_CATALOG_FILES"; then XML_CATALOG_FILES=" "; fi
    envHooks=(${envHooks[@]} addXMLCatalogs)
fi
