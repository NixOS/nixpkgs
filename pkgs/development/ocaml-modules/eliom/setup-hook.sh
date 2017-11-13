addOcsigenDistilleryTemplate() {
    prependToSearchPathWithCustomDelimiter : ELIOM_DISTILLERY_PATH $1/eliom-distillery-templates
}

envHooks+=(addOcsigenDistilleryTemplate)
