import run_tribler

def main() -> None:
    """
    Synchronous script entry point for use with setuptools.
    """
    if sys.platform == "win32":
        asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
    asyncio.run(run_tribler.main())
