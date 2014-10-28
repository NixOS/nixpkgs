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

    # Set up XML_CATALOG_FILES.  An empty initial value prevents
    # xmllint and xsltproc from looking in /etc/xml/catalog.
    export XML_CATALOG_FILES
    if test -z "$XML_CATALOG_FILES"; then XML_CATALOG_FILES=" "; fi
    envHooks=(${envHooks[@]} addXMLCatalogs)
fi
