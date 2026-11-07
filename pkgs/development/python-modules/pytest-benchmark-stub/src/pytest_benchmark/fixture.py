class BenchmarkFixture:
    def __init__(self):
        self.extra_info = {}

    def __call__(self, function, *args, **kwargs):
        return function(*args, **kwargs)

    def pedantic(self, function, *, setup=None, args=(), kwargs=None, **_):
        if setup is not None:
            setup()
        return function(*args, **(kwargs or {}))
