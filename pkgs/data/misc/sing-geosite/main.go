func main() {
	outputFile, err := os.Create("geosite.db")
	if err != nil {
		panic(err)
	}
	defer outputFile.Close()
	vData, err := ioutil.ReadFile("@geosite_data@")
	if err != nil {
		panic(err)
	}
	domainMap, err := parse(vData)
	if err != nil {
		panic(err)
	}
	err = geosite.Write(outputFile, domainMap)
	if err != nil {
		panic(err)
	}
}
