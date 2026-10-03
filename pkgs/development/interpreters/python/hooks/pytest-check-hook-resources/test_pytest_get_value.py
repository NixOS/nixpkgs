def test_pytestconfig_getoption_addopts(pytestconfig):
    with open(3, "w") as output_file:
        print(pytestconfig.getoption("addopts", ""), end="", file=output_file)
