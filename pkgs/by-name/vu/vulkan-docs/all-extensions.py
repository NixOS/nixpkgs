import sys
sys.path.insert(0, 'scripts')
from extdependency import ApiDependencies
print(" ".join(sorted(ApiDependencies().allExtensions())), end='')
